import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Booking {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'timestamp' })
  datetime: Date;

  @Column({ type: 'int' })
  duration: number; //  seconds

  @Column({ type: 'varchar', length: 50 })
  description: string;
}
