export const validateData = ({authorId , imageSet}) => {
    if(authorId === ""){
        return false
    }
    else{
        if(!imageSet.length >0 ){
            return false
        }else{
            return true
        }
    }
}