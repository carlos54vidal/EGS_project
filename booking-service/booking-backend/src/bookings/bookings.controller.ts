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
  Query,
} from '@nestjs/common';
import { ApiSecurity, ApiOperation, ApiTags, ApiQuery } from '@nestjs/swagger';
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

  private getApiKey(request: Request): string {
    const apikey = request.headers['api-key'];
    return Array.isArray(apikey) ? apikey.join(',') : apikey;
  }

  @Post()
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Add a new booking',
    description: 'Create a new booking',
  })
  create(@Req() request: Request, @Body() data: CreateBookingDto) {
    const key = this.getApiKey(request);
    return this.bookingsService.create(key, data);
  }

  @Get()
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Retrieve bookings based on various criteria',
    description:
      'This endpoint allows retrieving bookings based on different criteria like month, year, date, or datetime range.',
  })
  @ApiQuery({
    name: 'month',
    type: 'number',
    required: false,
    description: 'The month number (1-12) to filter bookings.',
  })
  @ApiQuery({
    name: 'year',
    type: 'number',
    required: false,
    description: 'The year to filter bookings.',
  })
  @ApiQuery({
    name: 'date',
    type: 'string',
    required: false,
    description: 'The specific date (YYYY-MM-DD) to filter bookings.',
  })
  @ApiQuery({
    name: 'start',
    type: 'string',
    required: false,
    description:
      'The start datetime range (ISO 8601 format) to filter bookings.',
  })
  @ApiQuery({
    name: 'end',
    type: 'string',
    required: false,
    description: 'The end datetime range (ISO 8601 format) to filter bookings.',
  })
  findAll(
    @Req() request: Request,
    @Query('month') month?: number,
    @Query('year') year?: number,
    @Query('date') date?: string,
    @Query('start') start?: string,
    @Query('end') end?: string,
  ) {
    const key = this.getApiKey(request);

    if (month && year) {
      // If month and year query parameters are provided, call a service method to fetch bookings for that month
      return this.bookingsService.findByMonthAndYear(key, month, year);
    } else if (date) {
      // If date query parameter is provided, call a service method to fetch bookings for that specific date
      return this.bookingsService.findByDate(key, date);
    } else if (start && end) {
      // If start and end datetime query parameters are provided, call a service method to fetch bookings within that datetime range
      return this.bookingsService.findByDatetimeRange(
        key,
        new Date(start),
        new Date(end),
      );
    } else {
      // Otherwise, return all bookings
      return this.bookingsService.findAll(key);
    }
  }

  @Get('checkAvailability')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Check if the booking is available',
    description:
      'This endpoint allows determining if a booking is available or not. It returns true if available and false otherwise',
  })
  @ApiQuery({
    name: 'datetime',
    type: 'string',
    required: true,
    description: 'The datetime (ISO 8601 format) of the booking.',
  })
  @ApiQuery({
    name: 'duration',
    type: 'number',
    required: true,
    description: 'The duration of the booking in seconds.',
  })
  checkAvailability(
    @Req() request: Request,
    @Query('datetime') datetime: string,
    @Query('duration') duration: number,
  ) {
    const key = this.getApiKey(request);
    return this.bookingsService.checkAvailability(
      key,
      new Date(datetime),
      duration,
    );
  }

  @Get('free-slots')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get all available bookings' })
  @ApiQuery({
    name: 'startDateTime',
    example: '2024-01-01T10:00:00Z',
  })
  @ApiQuery({
    name: 'endDateTime',
    example: '2024-01-01T11:00:00Z',
  })
  findFree(
    @Req() request: Request,
    @Query('startDateTime') start: Date,
    @Query('endDateTime') end: Date,
  ) {
    const key = this.getApiKey(request);
    return this.bookingsService.findAllFree(key, start, end);
  }

  @Get(':bookingId')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get a booking by uuid' })
  findOne(@Req() request: Request, @Param('bookingId') id: string) {
    const key = this.getApiKey(request);
    return this.bookingsService.findOne(key, id);
  }

  @Patch(':bookingId')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Edit a booking by uuid',
    description: 'Update an existing booking by Id',
  })
  update(
    @Req() request: Request,
    @Param('bookingId') id: string,
    @Body() data: UpdateBookingDto,
  ) {
    const key = this.getApiKey(request);
    return this.bookingsService.update(key, id, data);
  }

  @Delete(':bookingId')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Remove a booking by uuid' })
  remove(@Req() request: Request, @Param('bookingId') id: string) {
    const key = this.getApiKey(request);
    return this.bookingsService.remove(key, id);
  }
}
