#!/bin/sh
printf "\nType Y and the script file will be removed automatically\n\n"
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
import "./App.css"

const App = () => {
    return (
        <div className="flrow jcen acen h100">
            <h1>Made with &lt;3 by Arghya Das for you⌀</h1>
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

printf "\nRunning Local Server...\n\n"

npm run dev

echo -e "Made with \xE2\x9D\xA4 by Arghya Das for you\xE2\x8C\x80"