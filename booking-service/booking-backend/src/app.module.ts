import { Module } from '@nestjs/common';
import { BookingsModule } from './bookings/bookings.module';
import { ClientsModule } from './clients/clients.module';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Client } from './clients/entities/client.entity';
import { AuthModule } from './auth/auth.module';
import { Booking } from './bookings/entities/booking.entity';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      //envFilePath: './.env',
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      // postgresql://username:password@host:port/database
      //url: 'postgresql://postgres:root@localhost:5433/bookingservice', // localhost
      //url: 'postgresql://postgres:root@postgres:5432/bookingservice', // with docker
      url: 'postgresql://user:password@booking-db-service:5432/bookingservice', // with kunernetes
      // host: 'localhost',
      // port: 5433,
      // username: 'postgres',
      // password: 'root',
      // database: 'bookingservice',
      logging: true,
      synchronize: true,
      entities: [Client, Booking],
      //autoLoadEntities: true,
    }),
    BookingsModule,
    ClientsModule,
  ],
})
export class AppModule {}
