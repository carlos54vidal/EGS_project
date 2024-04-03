import { HttpStatus, Injectable } from '@nestjs/common';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';
import { Booking } from './entities/booking.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClientsService } from 'src/clients/clients.service';
import { ReadBooking } from './bookings.interface';
import { isOverlapping } from 'utils/bookings-operations';
import { exit } from 'process';

@Injectable()
export class BookingsService {
  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    private readonly clientsService: ClientsService,
  ) {}

  async create(
    apikey: string | string[],
    { datetime, duration, description }: CreateBookingDto,
  ) {
    try {
      let key: string = Array.isArray(apikey) ? apikey.join(',') : apikey;

      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // Get all client bookings and check if a booking already exists at the specified datetime
      const isBookingExists = await this.bookingRepository.find({
        relations: ['client'],
        where: { client: { id: clientId }, datetime: datetime },
      });
      // console.log('\nClient Bookings ');
      // console.log(isBookingExists);

      if (isBookingExists.length === 0) {
        console.log('\nBooking datetime dosent exists!');
        // Check if there is overlapping with other bookings
        let overlappingExists: boolean = false;
        const clientBookings = await this.bookingRepository.find({
          relations: ['client'],
          where: { client: { id: clientId } },
        });

        clientBookings.forEach((existingBooking) => {
          if (isOverlapping(existingBooking, { datetime, duration })) {
            console.log('Overlapping !! ');
            overlappingExists = true; // Overlapping booking found
            return; // Exit from forEach loop early
          }
        });

        if (!overlappingExists) {
          console.log('Overlapping dosent exists ! Creating booking ');
          const booking = this.bookingRepository.create({
            datetime,
            duration,
            description,
            client,
          });
          await this.bookingRepository.save(booking);
        } else {
          return {
            statusCode: HttpStatus.CONFLICT,
            message: 'Booking failed. There is a scheduling conflict.',
          };
        }
      } else {
        return {
          statusCode: HttpStatus.CONFLICT,
          message: 'Sorry, booking already exists at this datetime.',
        };
      }
      return {
        statusCode: HttpStatus.CREATED,
        message: 'Meeting booked successfully.',
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findAll(apikey: string | string[]) {
    const clientBookings: ReadBooking[] = [];
    try {
      let key: string = Array.isArray(apikey) ? apikey.join(',') : apikey;

      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // Get all the bookings of the client through is id
      const bookings = await this.bookingRepository.find({
        relations: ['client'],
        where: { client: { id: clientId } },
      });

      bookings.map((booking) => {
        clientBookings.push({
          bookingId: booking.id,
          datetime: booking.datetime,
          duration: booking.duration,
          description: booking.description,
        });
      });

      return clientBookings;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findOne(apikey: string | string[], bookingId: string) {
    try {
      let key: string = Array.isArray(apikey) ? apikey.join(',') : apikey;

      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // MISSING: check if bookingId exists !!!

      // Get the bookind id requested of the client through is id
      const booking = await this.bookingRepository.findOne({
        where: { id: bookingId },
        relations: ['client'],
      });

      // Check if api-key is the one

      return {
        datetime: booking.datetime,
        duration: booking.duration,
        description: booking.description,
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findAllFree(
    apikey: string | string[],
    startDatetime: Date,
    endDatetime: Date,
  ) {
    try {
      let key: string = Array.isArray(apikey) ? apikey.join(',') : apikey;
      let freeSlots: { start: Date; end: Date }[] = [];

      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // Get client bookings through his id
      const clientBookings = await this.bookingRepository.find({
        where: { client: { id: clientId } },
        relations: ['client'],
      });

      // Sort bookings by datetime
      clientBookings.sort(
        (a, b) => a.datetime.getTime() - b.datetime.getTime(),
      );

      // Initialize free slot with start and end of the provided interval
      let freeSlotStart = startDatetime;
      let freeSlotEnd = endDatetime;

      // Iterate through bookings to find free slots
      for (const booking of clientBookings) {
        const existingStart = booking.datetime;
        const existingDuration = booking.duration;
        const existingEnd = new Date(
          existingStart.getTime() + existingDuration * 1000,
        );

        // Check if there's a gap before the current booking
        if (existingStart > freeSlotStart) {
          freeSlots.push({ start: freeSlotStart, end: existingStart });
        }

        // Update free slot range
        freeSlotStart = existingEnd;
      }

      // Check if there's a gap after the last booking
      if (freeSlotStart < freeSlotEnd) {
        freeSlots.push({ start: freeSlotStart, end: freeSlotEnd });
      }

      return freeSlots;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findAllBusy(apikey: string | string[], start: Date, end: Date) {
    try {
      let key: string = Array.isArray(apikey) ? apikey.join(',') : apikey;
      let busySlots: { start: Date; end: Date }[] = [];

      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // Get client bookings through his id
      const clientBookings = await this.bookingRepository.find({
        where: { client: { id: clientId } },
        relations: ['client'],
      });

      clientBookings.forEach((booking) => {
        const existingStart = booking.datetime;
        const existingDuration = booking.duration;
        const existingEnd = new Date(
          existingStart.getTime() + existingDuration * 1000,
        );

        // Check for overlap
        if (
          (existingStart >= start && existingStart <= end) ||
          (existingEnd >= start && existingEnd <= end) ||
          (existingStart <= start && existingEnd >= end)
        ) {
          // Booking overlaps with the provided time range, exclude it
          return;
        }

        // Add the slot as busy slot
        busySlots.push({ start: existingStart, end: existingEnd });
      });

      return busySlots;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async update(
    apikey: string | string[],
    bookingId: string,
    { datetime, duration, description }: UpdateBookingDto,
  ) {
    // Update booking values
    try {
      // Check if booking with bookingId exists

      // Check if api-key is the one

      await this.bookingRepository.update(bookingId, {
        datetime,
        duration,
        description,
      });
      return {
        statusCode: HttpStatus.OK,
        message: 'Booking updated !',
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async remove(apikey: string | string[], bookingId: string) {
    try {
      // Check if booking with bookingId exists

      // Check if api-key is the one

      await this.bookingRepository.delete(bookingId); // delete a dispenser from the database
      return {
        statusCode: HttpStatus.OK,
        message: 'Booking deleted !',
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }
}
