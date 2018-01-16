const express       =       require('express');
const morgan        =       require('morgan');
const bodyParser    =       require('body-parser');
const app           =       express();
const request       =       require('request');
const crypto        =       require('crypto');
const url           =       require('url');

const credentials   =       require('./credentials');


const PORT = process.env.PORT || 3000;

app.use(morgan('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
// build the authHeader from your app's credentials.
const authHeader = 'Basic ' + new Buffer(credentials.CLIENT_ID + ":" + credentials.CLIENT_SECRET).toString('base64');

// ---------------------------------------------------------------------------------

app.post('/swapToken', function (req, res, next) {
  if (req.body.code) {
    return swapToken(req, res, next);
  } else {
    return refreshToken(req, res, next);
  }
});

function swapToken(req, res, next) {
  var formData = {
          grant_type : 'authorization_code',
          redirect_uri : credentials.CLIENT_CALLBACK,
          code : req.body.code
      },
      options = {
          uri : url.parse('https://accounts.spotify.com/api/token'),
          headers : {
              'Authorization' : authHeader
          },
          form : formData,
          method : 'POST',
          json : true
      };

  request(options, function (error, response, body) {
    console.log(JSON.stringify(body, 0, 2));
      if (response.statusCode === 200) {
          body.refresh_token = encrypt(body.refresh_token);
      }
      
      res.status(response.statusCode);
      res.json(body);
      next();
  });
}

// ---------------------------------------------------------------------------------

function refreshToken(req, res, next) {
  if (!req.body.refresh_token) {
      res.status(400).json({ error : 'Refresh token is missing from body' });
      return;
  }

  var refreshToken = decrypt(req.body.refresh_token);

  var formData = {
                    grant_type : 'refresh_token',
                    refresh_token : refreshToken
                  };
  var options = {
                  uri : url.parse('https://accounts.spotify.com/api/token'),
                  headers : {
                      'Authorization' : authHeader
                  },
                  form : formData,
                  method : 'POST',
                  json : true
                };

  request(options, function (error, response, body) {
    if (response.statusCode === 200 && !!body.refresh_token) {
        body.refresh_token = encrpytion.encrypt(body.refresh_token);
    }

    res.status(response.statusCode);
    res.json(body);

    next();
  });
};

// ---------------------------------------------------------------------------------

function encrypt (text) {
  var cipher = crypto.createCipher('aes-256-ctr', credentials.ENCRYPTION_SECRET),
  crypted = cipher.update(text, 'utf8', 'hex');
  crypted += cipher.final('hex');
  return crypted;
};

function decrypt (text) {
  var decipher = crypto.createDecipher('aes-256-ctr', credentials.ENCRYPTION_SECRET),
  dec = decipher.update(text, 'hex', 'utf8');
  dec += decipher.final('utf8');
  return dec;
}

// ---------------------------------------------------------------------------------

app.listen(PORT, function () {
  console.log(`Example app listening on port ${PORT}!`)
});