import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { Request, Response } from 'express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // enable cors and global prefix for apis
  app.enableCors();
  app.setGlobalPrefix('v1/');
  app.useGlobalPipes(new ValidationPipe());

  // Define a middleware to intercept all incoming requests
  app.use((req: Request, res: Response, next: Function) => {
    // Check if the request is for the root endpoint
    if (req.url === '/') {
      // If so, send a custom message
      res.send('PETCARE - Welcome to the Booking API!');
    } else {
      // If not, proceed with the next middleware
      next();
    }
  });

  const config = new DocumentBuilder()
    .setTitle('Booking API')
    .setDescription('The bookings API description')
    .setVersion('1.0')
    .addApiKey({ type: 'apiKey', name: 'Api-Key', in: 'header' }, 'Api-Key')
    //.addTag('bookings')
    .build();

  const document = SwaggerModule.createDocument(app, config, {
    ignoreGlobalPrefix: false,
  });
  // const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(8040);
}
bootstrap();
