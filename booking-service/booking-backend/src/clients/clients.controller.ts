import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { ClientsService } from './clients.service';
import { CreateClientDto } from './dto/create-client.dto';
import { UpdateClientDto } from './dto/update-client.dto';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('Clients')
@Controller('clients')
export class ClientsController {
  constructor(private readonly clientsService: ClientsService) {}

  @ApiOperation({
    summary: 'Add a new client',
    description: 'Create a new client',
  })
  @Post()
  create(@Body() data: CreateClientDto) {
    return this.clientsService.create(data);
  }

  @ApiOperation({
    summary: 'Get all the clients from the bookings service.',
  })
  @Get()
  findAll() {
    return this.clientsService.findAll();
  }

  @ApiOperation({
    summary: 'Get a client from the bookings service by client id.',
  })
  @Get(':clientId')
  findOne(@Param('clientId') id: string) {
    return this.clientsService.findOne(id);
  }

  @ApiOperation({
    summary: 'Update a client from the bookings service by client id.',
  })
  @Patch(':clientId')
  update(@Param('clientId') id: string, @Body() data: UpdateClientDto) {
    return this.clientsService.update(id, data);
  }

  @ApiOperation({
    summary: 'Remove a client from the bookings service by client id.',
  })
  @Delete(':clientId')
  remove(@Param('clientId') id: string) {
    return this.clientsService.remove(id);
  }
}
