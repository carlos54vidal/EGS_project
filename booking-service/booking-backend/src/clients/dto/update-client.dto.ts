import { PartialType, PickType } from '@nestjs/swagger';
import { CreateClientDto } from './create-client.dto';

export class UpdateClientDto extends PartialType(
  PickType(CreateClientDto, ['name'] as const),
) {}
