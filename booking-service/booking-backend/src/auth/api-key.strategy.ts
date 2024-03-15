import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { HeaderAPIKeyStrategy } from 'passport-headerapikey';

@Injectable()
export class ApiKeyStrategy extends PassportStrategy(HeaderAPIKeyStrategy) {
  constructor(private authService: AuthService) {
    super({ header: 'Api-Key', prefix: '' }, true, (apikey, done) => {
      // validate the client api key
      const isValid = authService.validateApiKey(apikey);
      if (!isValid) {
        return done(new UnauthorizedException('Invalid API key'), false);
      }
      return done(null, true);
    });
  }
}
