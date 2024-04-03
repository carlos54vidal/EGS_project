import { Injectable } from '@nestjs/common';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';

@Injectable()
export class AppService {
  create(data: CreateBookingDto) {
    return 'This action adds a new booking';
  }

  findAll() {
    return [
      {
        bookingId: 'fbdbd444-1509-46e3-b1d9-a6f0aa2a8bc2',
        datetime: '2024-03-20T09:36:39.948Z',
        duration: 10000,
        description: 'booking description',
      },
      {
        bookingId: 'fbdbd444-1509-46e3-b1d9-a6f0aa2a8bc2',
        datetime: '2024-03-20T09:36:39.948Z',
        duration: 10000,
        description: 'booking description',
      },
    ];
  }

  findAllFree() {
    return [
      {
        startime: '2024-03-20T09:32:14.258Z',
        endtime: '2024-03-20T09:32:14.258Z',
      },
      {
        startime: '2024-03-20T09:32:14.258Z',
        endtime: '2024-03-20T09:32:14.258Z',
      },
    ];
  }

  findAllBusy() {
    return [
      {
        startime: '2024-03-20T09:32:14.258Z',
        endtime: '2024-03-20T09:32:14.258Z',
      },
      {
        startime: '2024-03-20T09:32:14.258Z',
        endtime: '2024-03-20T09:32:14.258Z',
      },
    ];
  }

  findOne(id: number) {
    return {
      bookingId: '7543785-323fdf2',
      datetime: '2024-03-20T09:36:39.948Z',
      duration: 10000,
      description: 'booking description',
    };
  }

  update(id: number, data: UpdateBookingDto) {
    return `This action updates a #${id} booking`;
  }

  remove(id: number) {
    return `This action removes a #${id} booking`;
  }
}
