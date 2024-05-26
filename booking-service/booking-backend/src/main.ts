import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { BookingsModule } from './bookings/bookings.module';
import { ClientsModule } from './clients/clients.module';
import { Request, Response } from 'express';
import { frontPage } from 'utils/front-page';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // enable cors and global prefix for apis
  app.enableCors();
  //app.setGlobalPrefix('booking-service'); // This global prefix will apply to all routes

  // Global validation pipe
  app.useGlobalPipes(new ValidationPipe());

  // Define a middleware to intercept all incoming requests
  app.use((req: Request, res: Response, next: Function) => {
    // Check if the request is for the root endpoint
    if (req.url === '/booking-service') {
      // If so, send a custom message
      //res.send('PETCARE - Welcome to the Booking API!');
      res.send(frontPage); // Send the imported HTML content
    } else {
      // If not, proceed with the next middleware
      next();
    }
  });

  // Swagger configuration for Bookings API
  const bookingConfig = new DocumentBuilder()
    .setTitle('Booking API')
    .setDescription(
      'The booking API allows users to manage all the bookings for a given client using their api-key.',
    )
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
    .setDescription(
      'The clients API allows managing all clients using the bookings service.',
    )
    .setVersion('1.0')
    .build();

  const clientDocument = SwaggerModule.createDocument(app, clientConfig, {
    include: [ClientsModule],
  });
  SwaggerModule.setup('booking-service/clients', app, clientDocument);

  await app.listen(8040);
}
bootstrap();
