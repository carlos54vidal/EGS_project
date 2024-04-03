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
    const apikey = request.headers['api-key'];
    return this.bookingsService.findAll(apikey);
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
    const apikey = request.headers['api-key'];
    return this.bookingsService.findAllFree(apikey, start, end);
  }

  @Get('busy-slots')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get all busy bookings' })
  @ApiQuery({
    name: 'startDateTime',
    example: '2024-01-01T10:00:00Z',
  })
  @ApiQuery({
    name: 'endDateTime',
    example: '2024-01-01T11:00:00Z',
  })
  findBusy(
    @Req() request: Request,
    @Query('startDateTime') start: Date,
    @Query('endDateTime') end: Date,
  ) {
    const apikey = request.headers['api-key'];
    return this.bookingsService.findAllBusy(apikey, start, end);
  }

  @Get(':uuid')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get a booking by uuid' })
  findOne(@Req() request: Request, @Param('uuid') id: string) {
    const apikey = request.headers['api-key'];
    return this.bookingsService.findOne(apikey, id);
  }

  @Patch(':uuid')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Edit a booking by uuid',
    description: 'Update an existing booking by Id',
  })
  update(
    @Req() request: Request,
    @Param('uuid') id: string,
    @Body() data: UpdateBookingDto,
  ) {
    const apikey = request.headers['api-key'];
    return this.bookingsService.update(apikey, id, data);
  }

  @Delete(':uuid')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Remove a booking by uuid' })
  remove(@Req() request: Request, @Param('uuid') id: string) {
    const apikey = request.headers['api-key'];
    return this.bookingsService.remove(apikey, id);
  }
}
