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
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';

@ApiTags('Clients')
@Controller('clients')
export class ClientsController {
  constructor(private readonly clientsService: ClientsService) {}

  @Post()
  @ApiOperation({
    summary: 'Add a new client',
    description: 'Create a new client',
  })
  @ApiResponse({
    status: 201,
    description: 'The client has been successfully created.',
    type: CreateClientDto,
  })
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
  @ApiResponse({ status: 404, description: 'The client was not found.' })
  findOne(@Param('clientId') id: string) {
    return this.clientsService.findOne(id);
  }

  @ApiOperation({
    summary: 'Get a client by api-key.',
  })
  @Get('/client/:apiKey')
  @ApiResponse({ status: 404, description: 'The client was not found.' })
  findByKey(@Param('apiKey') apiKey: string) {
    return this.clientsService.findByKey(apiKey);
  }

  @ApiOperation({
    summary: 'Update a client from the bookings service by client id.',
  })
  @ApiResponse({
    status: 200,
    description: 'The client has been successfully updated.',
  })
  @ApiResponse({ status: 404, description: 'The client was not found.' })
  @Patch(':clientId')
  update(@Param('clientId') id: string, @Body() data: UpdateClientDto) {
    return this.clientsService.update(id, data);
  }

  @ApiOperation({
    summary: 'Remove a client from the bookings service by client id.',
  })
  @Delete(':clientId')
  @ApiResponse({
    status: 200,
    description: 'The client has been successfully deleted.',
  })
  @ApiResponse({ status: 404, description: 'The client was not found.' })
  @ApiResponse({
    status: 409,
    description: 'Internal Server Error. The client can have bookings.',
  })
  remove(@Param('clientId') id: string) {
    return this.clientsService.remove(id);
  }
}
