import { HttpStatus, Injectable } from '@nestjs/common';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';
import { Booking } from './entities/booking.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClientsService } from 'src/clients/clients.service';
import { ReadBooking } from './bookings.interface';
import { isISODateString, isOverlapping } from 'utils/bookings-operations';

@Injectable()
export class BookingsService {
  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    private readonly clientsService: ClientsService,
  ) {}

  async create(key: string, data: CreateBookingDto) {
    const { bookingId, datetime, duration, description } = data;

    try {
      if (!bookingId) {
        // Booking id is not given as parameter

        /** Get all client bookings by his api-key and check
         * if a booking already exists at the specified datetime */
        const client = await this.clientsService.findOne(key);
        const clientId = client.id;
        const isBookingExists = await this.bookingRepository.find({
          relations: ['client'],
          where: { client: { id: clientId }, datetime: datetime },
        });

        if (isBookingExists.length === 0) {
          // Check if there is overlapping with other bookings
          let overlappingExists: boolean = false;
          const bookings = await this.bookingRepository.find({
            relations: ['client'],
            where: { client: { id: clientId } },
          });

          bookings.forEach((existingBooking) => {
            if (
              isOverlapping(existingBooking, {
                datetime: datetime,
                duration: duration,
              })
            ) {
              overlappingExists = true; // Overlapping booking found
              return; // Exit from forEach loop early
            }
          });

          if (!overlappingExists) {
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
      } else {
        // Booking id is given as parameter

        /******* Check if bookingId already exists */
        const isBookingIdExists = await this.bookingRepository.find({
          where: { id: bookingId },
        });

        if (!isBookingIdExists) {
          /** Get all client bookings by his api-key and check
           * if a booking already exists at the specified datetime */
          const client = await this.clientsService.findOne(key);
          const clientId = client.id;
          const isBookingExists = await this.bookingRepository.find({
            relations: ['client'],
            where: { client: { id: clientId }, datetime: datetime },
          });

          if (isBookingExists.length === 0) {
            // Check if there is overlapping with other bookings
            let overlappingExists: boolean = false;
            const bookings = await this.bookingRepository.find({
              relations: ['client'],
              where: { client: { id: clientId } },
            });

            bookings.forEach((existingBooking) => {
              if (
                isOverlapping(existingBooking, {
                  datetime: datetime,
                  duration: duration,
                })
              ) {
                overlappingExists = true; // Overlapping booking found
                return; // Exit from forEach loop early
              }
            });

            if (!overlappingExists) {
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
        } else {
          return {
            statusCode: HttpStatus.CONFLICT,
            message: 'Sorry, booking id already exists',
          };
        }
      }
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async checkAvailability(
    key: string,
    datetime: Date,
    duration: number,
  ): Promise<boolean> {
    // Identify clientId through api-key
    const client = await this.clientsService.findOne(key);
    const clientId = client.id;

    // Get all the bookings of the client through is id
    const bookings = await this.bookingRepository.find({
      relations: ['client'],
      where: { client: { id: clientId } },
    });

    let overlappingExists: boolean = false;
    bookings.forEach((existingBooking) => {
      if (
        isOverlapping(existingBooking, {
          datetime: datetime,
          duration: duration,
        })
      ) {
        overlappingExists = true; // Overlapping booking found
        return; // Exit from forEach loop early
      }
    });

    // If there is an overlapping booking, the slot is not available
    return !overlappingExists;
  }

  async findAll(key: string) {
    const clientBookings: ReadBooking[] = [];
    try {
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

  async findByMonthAndYear(key: string, month: number, year: number) {
    const clientBookings: ReadBooking[] = [];

    console.log('month:', month);

    console.log('year:', year);

    try {
      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // Get all the bookings of the client through is id
      const bookings = await this.bookingRepository.find({
        relations: ['client'],
        where: { client: { id: clientId } },
      });

      if (month && year) {
        //console.log('Month and year');
        bookings.map((booking) => {
          const bookingDateYear = booking.datetime.getFullYear();
          const bookingDateMonth = booking.datetime.getMonth() + 1;
          if (bookingDateYear == year && bookingDateMonth == month) {
            clientBookings.push({
              bookingId: booking.id,
              datetime: booking.datetime,
              duration: booking.duration,
              description: booking.description,
            });
          }
        });
      } else if (month) {
        //console.log('Month');
        bookings.map((booking) => {
          const bookingDateMonth = booking.datetime.getMonth() + 1;
          if (bookingDateMonth == month) {
            clientBookings.push({
              bookingId: booking.id,
              datetime: booking.datetime,
              duration: booking.duration,
              description: booking.description,
            });
          }
        });
      } else if (year) {
        //console.log('year');
        bookings.map((booking) => {
          const bookingDateYear = booking.datetime.getFullYear();
          if (bookingDateYear == year) {
            clientBookings.push({
              bookingId: booking.id,
              datetime: booking.datetime,
              duration: booking.duration,
              description: booking.description,
            });
          }
        });
      }

      return clientBookings;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findByDate(key: string, date: string) {
    const clientBookings: ReadBooking[] = [];
    try {
      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // Get all the bookings of the client through is id
      const bookings = await this.bookingRepository.find({
        relations: ['client'],
        where: { client: { id: clientId } },
      });

      bookings.map((booking) => {
        const bookingDate = booking.datetime.toISOString().split('T')[0];
        if (date === bookingDate) {
          clientBookings.push({
            bookingId: booking.id,
            datetime: booking.datetime,
            duration: booking.duration,
            description: booking.description,
          });
        }
      });

      return clientBookings;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findByDatetimeRange(key: string, start: string, end: string) {
    const clientBookings: ReadBooking[] = [];
    try {
      if (!isISODateString(start) && isISODateString(end)) {
        return {
          statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
          message: 'The DateTime is not in ISO format.',
        };
      }

      const startDate = new Date(start);
      const endDate = new Date(end);

      // Identify clientId through api-key
      const client = await this.clientsService.findOne(key);
      const clientId = client.id;

      // Get all the bookings of the client through is id
      const bookings = await this.bookingRepository.find({
        relations: ['client'],
        where: { client: { id: clientId } },
      });

      console.log(start);

      console.log(end);

      bookings.map((booking) => {
        const bookingDate = booking.datetime;
        console.log(bookingDate);
        if (bookingDate >= startDate && bookingDate <= endDate) {
          console.log('Inside');
          clientBookings.push({
            bookingId: booking.id,
            datetime: booking.datetime,
            duration: booking.duration,
            description: booking.description,
          });
        }
      });

      return clientBookings;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findOne(key: string, bookingId: string) {
    try {
      const isBookingExists = await this.bookingRepository.find({
        where: { id: bookingId },
      });

      if (isBookingExists) {
        // Get the booking information
        const booking = await this.bookingRepository.findOne({
          where: { id: bookingId },
          relations: ['client'],
        });
        return {
          datetime: booking.datetime,
          duration: booking.duration,
          description: booking.description,
        };
      } else {
        return {
          statusCode: HttpStatus.NOT_FOUND,
          message: 'Sorry, booking requested doesnt exist.',
        };
      }
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findAllFree(key: string, startDatetime: Date, endDatetime: Date) {
    try {
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

  async update(
    key: string,
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

  async remove(key: string, bookingId: string) {
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
