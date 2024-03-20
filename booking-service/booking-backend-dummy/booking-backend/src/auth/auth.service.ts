import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  // KEYS
  //   private apiKeys: string[] = [
  //     'ca03na188ame03u1d78620de67282882a84',
  //     'd2e621a6646a4211768cd68e26f21228a81',
  //   ];

  private apiKey: string = '12345';

  validateApiKey(apiKey: string): boolean {
    // return this.apiKeys.find((key) => key === apiKey);
    return this.apiKey === apiKey;
  }
}
