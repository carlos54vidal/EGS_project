import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiKeyStrategy } from './api-key.strategy';
import { PassportModule } from '@nestjs/passport';
import { AuthMiddleware } from './auth.middleware';

@Module({
  imports: [PassportModule.register({ defaultStrategy: 'apiKey' })],
  providers: [AuthService, ApiKeyStrategy],
})
export class AuthModule {}
