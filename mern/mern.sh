#!/bin/sh

# Backend part

touch .gitignore

echo "node_modules" > .gitignore

mkdir server

cd server

npm init -y

npm i express cors mongoose

backend=$(cat <<EOF
const Express = require('express') ;
const cors = require('cors') ;
const mongoose = require('mongoose') ;

const app = Express() ;
app.use(cors()) ;
app.use(Express.json({limit: '50mb'})) ;

// :::: Important Settings :::::
const port = 8000
mongoose.connect('mongodb://127.0.0.1:27017/testDB' , {
    useNewUrlParser : true,
    useUnifiedTopology :true
})
.then(()=> console.log('MongoDB connected') )
.catch((err) => console.log('Unable to connect Databse\n',err)) ;

const userSchema = new mongoose.Schema({
    id: Number,
    name: String
});

const User = mongoose.model('User',userSchema) ;
// :::::::::


app.get("/",(req,res)=> {
    res.status(200).json("Hello from the Backend") ;
});

//:::: CRUD Operations :: Delete this section if you need a cleaner enviroment
app.get("/user", async (req,res)=> {
    try {
        const users = await User.find({});
        return res.status(200).json({users: users , msg: "Successfull"});
    }
    catch (err){
        console.log(err) ;
        res.status(500).json({msg: "Some Error Occurred"}) ;
    }
})
app.post("/user", async (req,res)=> {
    const userName = req.body.name ;
    if (!userName){
        console.log("Unable to fetch User Name") ;
        return res.status(500).json({msg: "Some Error Occurred"}) ;
    }

    try {
        const newId = ( await User.countDocuments({}) ) + 1 ;
        const newUser = new User({id: newId , name: userName}) ;
        await newUser.save() ;
        res.status(200).json({msg: "Successfully Added"}) ;
    }
    catch(err) {
        console.log(err);
        res.status(500).json({msg: "Some Error Occurred"}) ;
    }
})
app.put("/user", async (req,res)=> {
    const userName = req.body.name ;
    const userId = req.body.id ;
    if (!userName || !userId){
        console.log("Unable to fetch User Data") ;
        return res.status(500).json({msg: "Some Error Occurred"}) ;
    }

    try {
        await User.updateOne({ id: userId },{ name: userName }) ;
        res.status(200).json({msg: "Successfully Updated"}) ;
    }
    catch(err) {
        console.log(err) ;
        res.status(500).json({msg: "Some Error Occured"}) ;
    }
})
app.delete("/user", async (req,res)=> {
    const userId = req.body.id ;
    if (!userId){
        console.log("Unable to fetch User Data") ;
        return res.status(500).json({msg: "Some Error Occurred"}) ;
    }

    try {
        await User.deleteOne({id: userId}) ;
        res.status(200).json({msg: "Successfully Deleted"}) ;
    }
    catch(err) {
        console.log(err) ;
        res.status(500).json({msg: "Some Error Occurred"}) ;
    }
})
// :::::::::::::::

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

.m1r {
    margin: 1rem;
}
.p1r {
    padding: 1rem;
}

EOF
)
echo "$v" > index.css

v=$(cat <<EOF
import "./App.css"
import Crud from "./Crud";

const App = () => {

    return (
        <div className="flrow jcen acen h100">
            <Crud/>
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

v=$(cat <<EOF
import { useState } from "react";

const Crud = () => {
    const [Data, setData] = useState([]) ;
	const [Msg, setMsg] = useState("") ;

    const create = async (e) => {
        e.preventDefault() ;
		try {
			const res = await fetch("http://localhost:8000/user", {
				method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
				body: JSON.stringify({ name: e.target.name.value }) 
			})
            const json = await res.json() ;
            setMsg(json.msg) ;
		}
		catch(err) {
			console.log(err) ;
            setMsg("Some Error Occurred") ;
        }
    }
    const read = async (e) => {
        e.preventDefault() ;
        try {
            const res = await fetch("http://localhost:8000/user", {
                method: "GET",
                headers: {
                    "Content-Type": "application/json"
                },
            })
            const json = await res.json() ;
            setData([...json.users]) ;
            setMsg(json.msg) ;
        }
        catch(err) {
            console.log(err) ;
            setMsg("Some Error Occurred") ;
        }
        
    }
    const update = async (e) => {
        e.preventDefault() ;
        try {
            const res = await fetch("http://localhost:8000/user", {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ id: e.target.id.value , name: e.target.name.value }) 
            })
            const json = await res.json() ;
            setMsg(json.msg) ;
        }
        catch(err) {
            console.log(err) ;
            setMsg("Some Error Occurred") ;
        }
    }
    const del = async (e) => {
        e.preventDefault() ;
        try {
            const res = await fetch("http://localhost:8000/user", {
                method: "DELETE",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({ id: e.target.id.value }) 
            })
            const json = await res.json() ;
            setMsg(json.msg) ;
        }
        catch(err) {
            console.log(err) ;
            setMsg("Some Error Occurred") ;
        }
    }
  return (
    <div className="flcol">
		<h3>{Msg}</h3>

        <div className="flcol m1r">
            <h3>Create</h3>
            <form onSubmit={create}>
				<label htmlFor="name">Name :</label>
                <input type="text" name="name" />
                <button type="submit" className="curpoi">Create</button>
            </form>
        </div>
        <div className="flcol m1r">
            <h3>Read</h3>
            <div className="flrow"> <p>Id</p> : <p>Name</p> </div>
			{Data.map((elem,ind) => (
				<div className="flrow" key={ind}> <p>{elem.id}</p> : <p>{elem.name}</p> </div>
			))}
            <form onSubmit={read}>
                <button type="submit" className="curpoi">🔃</button>
            </form>
        </div>
        <div className="flcol m1r">
            <h3>Update</h3>
            <form onSubmit={update}>
				<label htmlFor="id">Id : </label>
                <input type="text" name="id" /> <br/>
				<label htmlFor="name">New name : </label>
                <input type="text" name="name" />
                <button type="submit" className="curpoi">Update</button>
            </form>
        </div>
        <div className="flcol m1r">
            <h3>Delete</h3>
            <form onSubmit={del}>
				<label htmlFor="id">Id :</label>
                <input type="text" name="id" />
                <button type="submit" className="curpoi">Delete</button>
            </form>
        </div>

    </div>
  )
}

export default Crud;
EOF
)

touch Crud.jsx
echo "$v" > Crud.jsx

printf "____________________________________________"

printf "\nSetting Up backend and frontend complete\n";

printf "Update backend name and other setting if you want\n\n"

printf "____________________________________________"

echo -e "Made with \xE2\x9D\xA4 by Arghya Das for you\xE2\x8C\x80"

printf "\n1. Run MongoDB server"
printf "\n2. Goto Client and Run"
printf "\nnpm run dev"
printf "\n1. Goto Sever and Run"
printf "\nnode index.js\n"