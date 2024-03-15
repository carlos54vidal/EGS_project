import { Injectable } from '@nestjs/common';
import { ClientsService } from 'src/clients/clients.service';

@Injectable()
export class AuthService {
  constructor(private readonly clientsService: ClientsService) {}

  //private apiKey: string = '12345';

  // Check if the api-key exists for a specific client
  async validateApiKey(apiKey: string): Promise<boolean> {
    //validateApiKey(apiKey: string): boolean {
    console.log('\nAuth Service: ');
    console.log('apiKey: ' + apiKey);
    console.log('Auth - Validating api-key...');

    const clientExists = await this.clientsService.findOne(apiKey);
    console.log(clientExists);
    if (clientExists) {
      console.log('Valid !! ');
      return true;
    }

    // if (this.apiKey === apiKey) {
    //   console.log('Valid !! ');
    //   return true;
    // }

    return false;
  }
}
