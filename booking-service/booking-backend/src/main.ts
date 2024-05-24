import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { BookingsModule } from './bookings/bookings.module';
import { ClientsModule } from './clients/clients.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // enable cors and global prefix for apis
  app.enableCors();
  app.setGlobalPrefix('v1/booking-service'); // This global prefix will apply to all routes

  // Global validation pipe
  app.useGlobalPipes(new ValidationPipe());

  // Swagger configuration for Bookings API
  const bookingConfig = new DocumentBuilder()
    .setTitle('Booking API')
    .setDescription('The bookings API description')
    .setVersion('1.0')
    .addApiKey({ type: 'apiKey', name: 'Api-Key', in: 'header' }, 'Api-Key')
    .build();

  const bookingDocument = SwaggerModule.createDocument(app, bookingConfig, {
    include: [BookingsModule],
  });
  SwaggerModule.setup('booking-service/bookings', app, bookingDocument);

  // Swagger configuration for Clients API
  const clientConfig = new DocumentBuilder()
    .setTitle('Clients API')
    .setDescription('The clients API description')
    .setVersion('1.0')
    .build();

  const clientDocument = SwaggerModule.createDocument(app, clientConfig, {
    include: [ClientsModule],
  });
  SwaggerModule.setup('booking-service/clients', app, clientDocument);

  // const config = new DocumentBuilder()
  //   .setTitle('Booking API')
  //   .setDescription('The bookings API description')
  //   .setVersion('1.0')
  //   .addApiKey({ type: 'apiKey', name: 'Api-Key', in: 'header' }, 'Api-Key')
  //   //.addTag('bookings')
  //   .build();

  // const document = SwaggerModule.createDocument(app, config, {
  //   ignoreGlobalPrefix: false,
  // });
  // // const document = SwaggerModule.createDocument(app, config);
  // SwaggerModule.setup('booking-api', app, document);

  await app.listen(8040);
}
bootstrap();
