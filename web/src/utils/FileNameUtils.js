export const alignFileName = (images) => {
    let fileNames = {};
    const modified = images.map( ({markerImg , modelImg}) => {
        let markerExt = markerImg.name.split('.').pop()
        let modelExt = modelImg.name.split('.').pop()

        let uniqueId = `file_${Date.now()}`;


        markerImg =  renameFile(markerImg ,`${uniqueId}.${markerExt}` )
        modelImg =  renameFile(modelImg ,`${uniqueId}.${modelExt}` )

        //set fileName in names

        fileNames = {...fileNames , 
            [`${uniqueId}.${markerExt}`] : `${uniqueId}.${modelExt}`
        }

        return {markerImg , modelImg}
    })
    return modified;
    
}




const renameFile = (file , newName) => {

    return new File([file], newName , {
        type : file.type,
        lastModified : file.lastModified
    })
}