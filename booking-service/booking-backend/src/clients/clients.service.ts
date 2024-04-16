import { HttpStatus, Injectable } from '@nestjs/common';
import { CreateClientDto } from './dto/create-client.dto';
import { UpdateClientDto } from './dto/update-client.dto';
import { generateApiKey } from 'utils/generateApiKey';
import { InjectRepository } from '@nestjs/typeorm';
import { Client } from './entities/client.entity';
import { Repository } from 'typeorm';

@Injectable()
export class ClientsService {
  constructor(
    @InjectRepository(Client)
    private readonly clientRepository: Repository<Client>,
  ) {}

  async create(data: CreateClientDto): Promise<any> {
    const name = data.name;
    const apikey = generateApiKey();

    try {
      // Check if name exists
      // ...

      const client = this.clientRepository.create({ name, apikey });
      await this.clientRepository.save(client);

      return { statusCode: HttpStatus.CREATED, message: 'Client created' };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findAll(): Promise<any> {
    try {
      const clients = this.clientRepository.find();
      return clients;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async findOne(id: string): Promise<any> {
    // Find Client
    try {
      const client = await this.clientRepository.findOneBy({ apikey: id });
      return client;
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async update(id: string, data: UpdateClientDto) {
    try {
      await this.clientRepository.update(id, data);
      return {
        statusCode: HttpStatus.OK,
        message: 'Client updated !',
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }

  async remove(id: string) {
    try {
      await this.clientRepository.delete(id);
      return {
        statusCode: HttpStatus.OK,
        message: 'Client deleted !',
      };
    } catch (error) {
      return {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Sorry, something went wrong',
      };
    }
  }
}
