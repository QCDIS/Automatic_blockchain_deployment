const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();


//Session
const session = require('express-session')

// Register the session with it's ID
app.use(session({
	secret: 'blockchain_id'
}))


//Body parser Middleware
app.use(bodyParser.json());
// Parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(cors());


const user_input = require('./routes/api/user_input');

app.use('/api/user_input', user_input);


const port = process.env.PORT || 5000;


app.listen(port, () => console.log(`Server started on port ${port}`));