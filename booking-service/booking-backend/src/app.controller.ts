import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { AppService } from './app.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { UpdateBookingDto } from './dto/update-booking.dto';
import { ApiSecurity, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from '@nestjs/passport';

@ApiSecurity('Api-Key')
@ApiTags('Booking')
@Controller('')
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Post()
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Add a new booking',
    description: 'Update an existing booking by Id',
  })
  create(@Body() data: CreateBookingDto) {
    return this.appService.create(data);
  }

  @Get()
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get all bookings' })
  findAll() {
    return this.appService.findAll();
  }

  @Get('free')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get all available bookings' })
  findAllFree() {
    return this.appService.findAllFree();
  }

  @Get('busy')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get all busy bookings' })
  findAllBusy() {
    return this.appService.findAllBusy();
  }

  @Get(':uuid')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Get a booking by uuid' })
  findOne(@Param('uuid') uuid: string) {
    return this.appService.findOne(+uuid);
  }

  @Patch(':uuid')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({
    summary: 'Edit a booking by uuid',
    description: 'Update an existing booking by Id',
  })
  update(@Param('uuid') uuid: string, @Body() data: UpdateBookingDto) {
    return this.appService.update(+uuid, data);
  }

  @Delete(':uuid')
  @UseGuards(AuthGuard('headerapikey'))
  @ApiOperation({ summary: 'Remove a booking by uuid' })
  remove(@Param('uuid') uuid: string) {
    return this.appService.remove(+uuid);
  }
}
