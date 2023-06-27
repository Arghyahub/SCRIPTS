#!/bin/sh

# Backend part

touch .gitignore

echo "node_modules" > .gitignore

mkdir server

cd server

npm init -y

npm i express cors 

backend=$(cat <<EOF
const Express = require('express') ;
const cors = require('cors') ;

const app = Express() ;
app.use(cors()) ;
app.use(Express.json({limit: '50mb'}))

const port = 8000

app.get("/",(req,res)=> {
    res.status(200).json("Hello from the Backend") ;
});

app.listen(port,() => {
    console.log("Server running") ;
});

EOF
)

touch index.js

echo "$backend" > index.js



# Frontend Part

cd ..

mkdir client

cd client/

npm create vite@latest .

cd public
rm vite.svg

npm install

cd ../src/
rm -r assets/
echo '' > App.css

v=$(cat <<EOF
html , body ,#root {
    height: 100%;
}
* {
    margin: 0;
    padding: 0;
}

.flrow {
    display: flex;
    flex-direction: row;
}
.flcol {
    display: flex;
    flex-direction: column;
}

.jcen {
    justify-content: center;
}
.acen {
    align-items: center;
}
.tcen {
    text-align: center;
}

.border {
    border: 2px solid red;
}
.curpoi {
    cursor: pointer;
}

.h100 {
    height: 100%;
}
.w100 {
    width: 100%;
}

EOF
)
echo "$v" > index.css

v=$(cat <<EOF
import { useEffect , useState } from "react" ;

import "./App.css"

const App = () => {
    const [Data,setData] = useState("Backend Server not Connected") ;
    useEffect(()=> {
        const getData = async () => {
            const output = await fetch("http://localhost:8000/") ; // Your backend link
            const json = await output.json() ;
            setData(json) ;
        }

        getData();
    },[])

    return (
        <div className="flrow jcen acen h100">
            <h1>{Data}</h1>
        </div>
    )
}

export default App;
EOF
)

if [ -f "App.jsx" ]; then
    echo "$v" > App.jsx
else
    echo "$v" > App.tsx
fi

printf "____________________________________________"

printf "\nSetting Up backend and frontend complete\n";

printf "Update backend name and other setting if you want\n\n"

printf "____________________________________________"

echo -e "Made with \xE2\x9D\xA4 by Arghya Das for you\xE2\x8C\x80"
