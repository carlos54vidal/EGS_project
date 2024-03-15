import { Module } from '@nestjs/common';
import { BookingsService } from './bookings.service';
import { BookingsController } from './bookings.controller';
import { AuthModule } from 'src/auth/auth.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Booking } from './entities/booking.entity';
import { Client } from 'src/clients/entities/client.entity';
import { ClientsService } from 'src/clients/clients.service';

@Module({
  imports: [AuthModule, TypeOrmModule.forFeature([Booking, Client])],
  controllers: [BookingsController],
  providers: [BookingsService, ClientsService],
})
export class BookingsModule {}
