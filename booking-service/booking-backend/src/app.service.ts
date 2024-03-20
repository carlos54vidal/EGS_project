import { Injectable } from '@nestjs/common';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';

@Injectable()
export class AppService {
  create(data: CreateBookingDto) {
    return 'Created booking';
  }

  findAll() {
    return [
      {
        datetime: '2024-03-20T09:32:14.258Z',
        duration: '10000',
        description: 'Booking description',
      },
      {
        datetime: '2024-03-20T09:32:14.258Z',
        duration: '50000',
        description: 'Booking description',
      },
    ];
  }

  findOne(id: number) {
    return {
      datetime: '2024-03-20T09:32:14.258Z',
      duration: '10000',
      description: 'Booking description',
    };
  }

  findAllFree() {
    return [
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
    ];
  }

  update(id: number, data: UpdateBookingDto) {
    return `This action updates a #${id} booking`;
  }

  remove(id: number) {
    return `This action removes a #${id} booking`;
  }
}
