import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDate, IsInt, IsOptional, IsString, IsUUID } from 'class-validator';

export class CreateBookingDto {
  @ApiPropertyOptional()
  @IsUUID()
  @IsOptional()
  bookingId: string;

  @ApiProperty({ type: 'string', format: 'date-time' })
  datetime: Date;

  @ApiProperty()
  @IsInt()
  duration: number;

  @ApiProperty()
  @IsString()
  description: string;
}
