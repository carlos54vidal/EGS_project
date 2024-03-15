import { Module } from '@nestjs/common';
import { BookingsModule } from './bookings/bookings.module';
import { ClientsModule } from './clients/clients.module';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Client } from './clients/entities/client.entity';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      //envFilePath: '.env',
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5433,
      username: 'postgres',
      password: 'root',
      database: 'bookingservice',
      logging: true,
      synchronize: true,
      entities: [Client],
      //autoLoadEntities: true,
    }),
    BookingsModule,
    ClientsModule,
  ],
})
export class AppModule {}
