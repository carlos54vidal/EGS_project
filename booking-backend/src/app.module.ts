import { Module } from '@nestjs/common';
import { BookingsModule } from './bookings/bookings.module';
import { ClientsModule } from './clients/clients.module';

@Module({
  imports: [BookingsModule],
})
export class AppModule {}
