import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class CreateClientDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  clientName: string;
}
