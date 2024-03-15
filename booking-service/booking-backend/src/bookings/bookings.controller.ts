import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Req,
} from '@nestjs/common';
import { ApiSecurity, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';
import { Request } from 'express';

@ApiSecurity('Api-Key')
@ApiTags('Booking')
@Controller('bookings')
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post()
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Add a new booking',
    description: 'Update an existing booking by Id',
  })
  create(@Req() request: Request, @Body() data: CreateBookingDto) {
    const apikey = request.headers['api-key'];
    return this.bookingsService.create(apikey, data);
  }

  @Get()
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get all bookings' })
  findAll(@Req() request: Request) {
    console.log('Bookings Controller - findAll');
    const apikey = request.headers['api-key'];
    return this.bookingsService.findAll();
  }

  @Get('free')
  @ApiOperation({ summary: 'Get all available bookings' })
  findFree() {
    return this.bookingsService.findAll();
  }

  @Get('busy')
  @ApiOperation({ summary: 'Get all busy bookings' })
  findBusy() {
    return this.bookingsService.findAll();
  }

  @Get(':uuid')
  @ApiOperation({ summary: 'Get a booking by uuid' })
  findOne(@Param('uuid') uuid: string) {
    return this.bookingsService.findOne(+uuid);
  }

  @Patch(':uuid')
  @ApiOperation({
    summary: 'Edit a booking by uuid',
    description: 'Update an existing booking by Id',
  })
  update(@Param('uuid') uuid: string, @Body() data: UpdateBookingDto) {
    return this.bookingsService.update(+uuid, data);
  }

  @Delete(':uuid')
  @ApiOperation({ summary: 'Remove a booking by uuid' })
  remove(@Param('uuid') uuid: string) {
    return this.bookingsService.remove(+uuid);
  }
}
