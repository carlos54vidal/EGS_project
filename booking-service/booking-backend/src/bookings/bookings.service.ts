import { HttpStatus, Injectable } from '@nestjs/common';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';
import { Booking } from './entities/booking.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClientsService } from 'src/clients/clients.service';
import { ReadBookings } from './bookings.interface';

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
      let key: string;
      if (Array.isArray(apikey)) {
        key = apikey.join(',');
      } else {
        key = apikey;
      }

      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);

      const booking = this.bookingRepository.create({
        datetime,
        duration,
        description,
        client,
      });
      await this.bookingRepository.save(booking);

      return { statusCode: HttpStatus.CREATED, message: 'Booking created' };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findAll(apikey: string | string[]) {
    const clientBookings: ReadBookings[] = [];
    try {
      let key: string;
      if (Array.isArray(apikey)) {
        key = apikey.join(',');
      } else {
        key = apikey;
      }

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
      let key: string;
      if (Array.isArray(apikey)) {
        key = apikey.join(',');
      } else {
        key = apikey;
      }

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
