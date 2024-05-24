import { HttpStatus, Injectable } from '@nestjs/common';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';
import { Booking } from './entities/booking.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClientsService } from 'src/clients/clients.service';
import { ReadBooking, freeSlot } from './bookings.interface';
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

      bookings.map((booking) => {
        const bookingDate = booking.datetime;
        //console.log(bookingDate);
        if (bookingDate >= startDate && bookingDate <= endDate) {
          //console.log('Inside');
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

  async findFreeSlots(key: string, start: string, end: string) {
    const freeSlots: freeSlot[] = [];

    try {
      if (!isISODateString(start) && isISODateString(end)) {
        return {
          statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
          message: 'The DateTime is not in ISO format.',
        };
      }

      // Get all bookings schedule within the range
      const bookings = await this.findByDatetimeRange(key, start, end);
      // Ensure bookings is an array before proceeding
      if (!Array.isArray(bookings)) {
        console.error('Failed to retrieve bookings.');
        return [];
      }
      // Sort bookings by start datetime
      bookings.sort((a, b) => a.datetime.getTime() - b.datetime.getTime());
      //console.log(bookings);

      let startDateTime = new Date(start);
      let endDateTime = new Date(end);
      // console.log(startDateTime);
      // console.log(endDateTime);

      // Iterate through bookings to find free slots
      for (const booking of bookings) {
        //console.log('startDateTime: ', startDateTime);
        const bookingStart = new Date(booking.datetime);
        const bookingEnd = new Date(
          bookingStart.getTime() + booking.duration * 1000,
        );
        // console.log('Booking Start: ', bookingStart);
        // console.log('Booking End: ', bookingEnd);

        if (startDateTime < bookingStart) {
          // Before bookingStart is FREE
          freeSlots.push({
            start: new Date(startDateTime),
            end: bookingStart,
          });
        }
        //console.log(freeSlots);

        // Move current datetime to the end of the current booking
        if (startDateTime < bookingEnd) {
          startDateTime = bookingEnd;
        }
      }

      // Check for free slots after the last booking
      if (startDateTime < endDateTime) {
        freeSlots.push({
          start: new Date(startDateTime),
          end: new Date(end),
        });
      }

      return freeSlots;
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

      if (isBookingExists.length !== 0) {
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

  async update(
    key: string,
    bookingId: string,
    { datetime, duration, description }: UpdateBookingDto,
  ) {
    // Update booking values
    try {
      const isBookingExists = await this.bookingRepository.find({
        where: { id: bookingId },
      });

      if (isBookingExists.length !== 0) {
        await this.bookingRepository.update(bookingId, {
          datetime,
          duration,
          description,
        });
        return {
          statusCode: HttpStatus.OK,
          message: 'Booking updated !',
        };
      } else {
        return {
          statusCode: HttpStatus.NOT_FOUND,
          message: 'Sorry, booking id requested doesnt exist.',
        };
      }
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async remove(key: string, bookingId: string) {
    console.log('Remove booking \n');

    console.log(bookingId);
    try {
      const isBookingExists = await this.bookingRepository.find({
        where: { id: bookingId },
      });

      if (isBookingExists.length !== 0) {
        await this.bookingRepository.delete(bookingId);
        return {
          statusCode: HttpStatus.OK,
          message: 'Booking deleted !',
        };
      } else {
        return {
          statusCode: HttpStatus.NOT_FOUND,
          message: 'Sorry, booking id requested doesnt exist.',
        };
      }
    } catch (error) {
      console.log(error);
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }
}
