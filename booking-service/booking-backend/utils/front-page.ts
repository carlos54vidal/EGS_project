export const frontPage = `

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

        <title>Booking Service</title>
        
        <style>
            body {
                font-family: Arial, sans-serif;
                background: radial-gradient(circle, hsla(205, 56%, 85%, 1) 0%, hsla(120, 6%, 97%, 1) 100%);
                padding: 50px;
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                align-items: center;
                gap: 40px;
                height: 70vh; /* Ensure the body takes the full height of the viewport */
                margin: 0; /* Remove default margin */
            }
            .center-box {
                background: white;
                padding: 50px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                max-width: 800px;
                width: 100%;
                max-height: 300px;
                height: 100%;
                display: flex;
                justify-content: space-between;
            }
            .register-title{
                width: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 5px;
            }
            form {
                display: flex;
                flex-direction: column;
                justify-content: flex-start;
                align-items: flex-start;
            }
            label {
                font-weight: bold;
                font-size: 13px;
            }
            input[type="text"] {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                box-sizing: border-box;
                border: 1px solid #ccc;
                border-radius: 10px;
                font-size: 13px;
                transition: border-color 0.3s ease, background-color 0.3s ease;
            }
            input[type="text"]:focus {
                border-color: #438ABD; 
                outline: none;
            }
            input[type="submit"] {
                background-color: #438ABD;
                color: white;
                padding: 10px 0;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-size: 13px;
                font-weight: bold;
                width: 250px;
              }
            input[type="submit"]:hover {
                background-color: #336B93;
            }
            .center-div {
                width: 100%;
                display: flex;
                justify-content: center;
            }
            .divider {
                width: 1px;
                background-color: #ccc;
                margin: 0 40px;
            }
            .button-with-arrow {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background-color: #438ABD;
                color: white;
                padding: 13px 20px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-size: 13px;
                font-weight: bold;
                width: 100%;
            }
            .button-with-arrow:hover {
                background-color: #336B93;
            }
            
        </style>
    </head>
    <body>
        <h1>Booking Service</h1>
        <div class="center-box">
            <div style="flex-grow: 1;">
                
                <div class="register-title">
                    <h3 style="margin: 0;">Register New Client</h3>
                    <h5 style="margin: 0; color: #A9A9A9;">Generate API-KEI</h5>
                </div>

                <br>
                <br>
                
                <form id="signup-form" >
                    <label for="cname">Client name</label>
                    <input required type="text" id="cname" name="cname" placeholder="Name" />
                    <br>
                    <div class="center-div">
                        <input type="submit" value="Sign Up" />
                    </div>
                </form>
            </div>

            <div class="divider"></div>

            <div style="flex-grow: 1;"> 
                <button class="button-with-arrow" onclick="location.href='/booking-service/bookings'">
                    API Booking Docs <i class="fa fa-arrow-right"></i>
                </button>
                <br>
                <button class="button-with-arrow" onclick="location.href='/booking-service/clients'">
                    Clients Management <i class="fa fa-arrow-right"></i>
                </button>
            </div>
        </div>

        <script>
            document.getElementById('signup-form').addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent the default form submission

            const name = document.getElementById('cname').value;

            fetch('http://localhost:8040/v1/booking-service/clients', {
                method: 'POST',
                headers: {
                    'Accept': '*/*',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    name: name
                })
            })
            .then(response => response.json())
            .then(data => {
                console.log('Success:', data);
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        });
        </script>
  </body>
</html>
`;
