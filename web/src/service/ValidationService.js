import { all } from "axios";

export const validateData = ({authorId , imageSet}) => {
    let validate = {
        valid :true,
        msg : ""
    }
    if(authorId === ""){
        validate.valid = false;
        validate.msg  = "Enter a valid Anchor Id";
    }
    else{
        if(!imageSet.length >0 ){
            validate.valid = false;
            validate.msg  = "Add atleast single set of data";
        }
        else{
            let allImages = imageSet.map(obj => Object.values(obj)).flat();
            if(allImages.includes(null)){
                validate.valid = false;
            validate.msg  = "Upload data for all the fields.";
            }
        }
    }
    return validate;
}

