import { HttpStatus, Injectable } from '@nestjs/common';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';
import { Booking } from './entities/booking.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClientsService } from 'src/clients/clients.service';

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

  findAll() {
    return `This action returns all booking`;
  }

  findOne(id: number) {
    return `This action returns a #${id} booking`;
  }

  update(id: number, data: UpdateBookingDto) {
    return `This action updates a #${id} booking`;
  }

  remove(id: number) {
    return `This action removes a #${id} booking`;
  }
}
