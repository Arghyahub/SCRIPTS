#!/bin/bash
echo "=> Hello from Arghya! Create a new react project"
echo -n "=> This dir(.) or different(folder_name) : "
read dir
echo -n "=> Will you be deploying on vercel?(y/n) : "
read vercel

if [ "$dir" = "." ]; then
    npm create vite@latest .
else
    npm create vite@latest $dir
    cd $dir
fi

# remove vite.svg and assets dir
rm public/vite.svg
rm -r src/assets
# empty out App.css and index.css
echo > src/App.css
echo > src/index.css

# App code
appcode=$(cat <<EOF
import "./App.css";

const App = () => {
  return <div>App</div>;
};

export default App;
EOF
)

# Clean up App.jsx or App.tsx
if [ -f "src/App.jsx" ]; then
    echo "$appcode" > src/App.jsx
fi
if [ -f "src/App.tsx" ]; then
    echo "$appcode" > src/App.tsx
fi

# tsconfig and eslintconfig
eslintconfig=$(cat <<EOF
module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react-hooks/recommended",
  ],
  ignorePatterns: ["dist", ".eslintrc.cjs"],
  parser: "@typescript-eslint/parser",
  plugins: ["react-refresh"],
  rules: {
    "react-refresh/only-export-components": [
      "warn",
      { allowConstantExport: true },
    ],
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": "warn",
    "@typescript-eslint/ban-types": "warn",
  },
};
EOF
)

tsconfig=$(cat <<EOF
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": false,
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "noFallthroughCasesInSwitch": false
  },
  "rules": {
    "no-unused-vars": false
  },
  "include": ["src", "/src/**.ts", "/src/**.tsx"],
  "exclude": ["node_modules"]
}
EOF
)

if [ -f ".eslintrc.cjs" ]; then
    echo "$eslintconfig" > .eslintrc.cjs
fi

if [ -f "tsconfig.app.json" ]; then
    echo "$tsconfig" > tsconfig.app.json
fi

# vercel file
vercelcode=$(cat <<EOF
{
    "rewrites": [
        {
            "source": "/(.*)",
            "destination": "/"
        }
    ]
}
EOF
)
if [ "$vercel" = "y" ] || [ "$vercel" = "Y" ]; then
    echo "$vercelcode" > vercel.json
fi

# Install dependencies
echo "==Installing react dependencies=="
npm install

# _____________________ Tailwind CSS ______________________

echo -ne "\n=> Do you want tailwindcss? (y/n) : "
read tailwind

tailwindconfig=$(cat <<EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
)

tailwinddirective=$(cat <<EOF
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
)

if [ "$tailwind" = "y" ] || [ "$tailwind" = "Y" ]; then
    npm install -D tailwindcss@latest postcss@latest autoprefixer@latest
    npx tailwindcss init -p
    echo "$tailwindconfig" > tailwind.config.js
    echo "$tailwinddirective" > src/index.css
    echo -e "=> Tailwind setup complete\n"
fi



# _____________________ React router ______________________

echo -ne "\n=> Do you want react-router-dom? (y/n) : "
read reactrouter

if [ "$reactrouter" = "y" ] || [ "$reactrouter" = "Y" ]; then
    npm install react-router-dom
    echo -e "=> react-router-dom installed\n"
fi

# _____________________ Zustand ______________________

echo -ne "=> Do you want Zustand? (y/n) : "
read zustand

if [ "$zustand" = "y" ] || [ "$zustand" = "Y" ]; then
    npm install zustand
    echo -e "=> Zustand installed\n"
fi

echo "=> Installation complete! Happy coding!"
echo -e "\n==> Execute: npm run dev <==\n"