#!/bin/sh

npm create vite@latest .

cd src/
rm -r assets/
echo '' > App.css
cd ..

echo -n "1. Do you need Tailwind? (y/n) "
read tw

echo -n "2. Do you need React-Router? (y/n) "
read rr

# echo -n "1. Do you need  (y/n)"
# read tw


# Tailwind related code

tsconfig="
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    \"./index.html\",
    \"./src/**/*.{js,ts,jsx,tsx}\"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
"


tsdir="
@tailwind base;
@tailwind components;
@tailwind utilities;
"

app="
import \"./App.css\"

const App = () => {
    return (
        <div className=\"h-screen w-screen bg-red-300 flex flex-row justify-center items-center\">
            <h1>Made with &lt;3 by Arghya Das for you⌀</h1>
        </div>
    )
}

export default App;
"

if [[ $tw=="y" || $tw=='Y' ]]; 
then
  npm install -D tailwindcss postcss autoprefixer
  npx tailwindcss init -p
  echo "$tsconfig" > tailwind.config.js
  echo "$tsdir" > src/App.css
  echo "$app" > src/App.jsx
fi


# React Router related code

app=$(cat <<EOF
import {
    createBrowserRouter,
    RouterProvider,
    Link
} from "react-router-dom";
import "./App.css"

const LinkBtns = () => {
    return (
        <div className="flex w-full justify-center gap-4">
            <Link to={'/'} className="px-2 py-1 bg-green-400 text-white rounded-md" >Home</Link>
            <Link to={'/demo'} className="px-2 py-1 bg-green-400 text-white rounded-md" >Demo</Link>
        </div>
    )
}

const router = createBrowserRouter([
    {
      path: "/",
      element: <div className="h-screen w-screen bg-red-300 flex flex-col justify-center items-center gap-10">
            <h1>Made with &lt;3 by Arghya Das for you⌀</h1>
            <LinkBtns />
      </div>
    },
    {
      path: "/demo",
      element: <div className="h-screen w-screen bg-red-300 flex flex-col justify-center items-center gap-10">
            <h1>Checkout my other projects <a href="https://cv-arghyahub.vercel.app/">Here</a></h1>
            <LinkBtns />
        </div>
    },
]);

const App = () => {
    return (
        <RouterProvider router={router} />
    )
}

export default App;
EOF
)

if [[ $rr=="y" || $rr=='Y' ]]; 
then
  npm install react-router-dom
  echo "$app" > src/App.jsx
  echo ""
  echo "If you are not using not using Tailwind, Ignore the tailwind classes"
  echo ""
fi


npm run dev
