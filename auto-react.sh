echo "Welcome to SCRIPTS" 
echo "Please choose an option from: react, react_express, mern or mern_clean."
read -p "Which script do you want to run: " script
echo "Running $script"

if [ $script == "react" ] 
then 
    bash ./react/react.sh
elif [ $script == "react_express" ] 
then
    bash ./react_express/react_express.sh
elif [ $script == "mern" ] 
then
    bash ./mern/mern.sh
elif [ $script == "mern_clean" ] 
then
    bash ./mern/mern_clean.sh
else
    echo "Please choose an option from react, react_express, mern, mern_clean."
fi