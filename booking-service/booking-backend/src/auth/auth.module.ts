import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AuthService } from './auth.service';
import { ApiKeyStrategy } from './api-key.strategy';
import { PassportModule } from '@nestjs/passport';
import { ClientsModule } from 'src/clients/clients.module';
import { ClientsService } from 'src/clients/clients.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Client } from 'src/clients/entities/client.entity';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'apiKey' }),
    TypeOrmModule.forFeature([Client]),
  ],
  providers: [AuthService, ApiKeyStrategy, ClientsService],
})
export class AuthModule {}
