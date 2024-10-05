import React, { memo } from 'react'
import './fileUpload.scss'
import { MdOutlineFileUpload } from "react-icons/md";
import { FaImage } from "react-icons/fa";

const FileUpload = memo(({placeholder,val,onChangeHandler ,index , name,fileType}) => {
  return (
    <>
    <label className='file_upload_label' htmlFor={`file_upload${name}_${index}`}>
      {
        val == null ?
        <>
        <MdOutlineFileUpload className='upload_icon_pending'/>
        <p className='label_text'>
          {placeholder}
        </p>
        </>
        :
        <>
        <FaImage className='upload_icon_success'/>
        <p className='label_text'>
          {val.name}
        </p>
        </>
      }
    </label>
    <input type='file' id={`file_upload${name}_${index}`}  className='file_upload' onChange={(e)=>onChangeHandler(e,index,name)} accept={fileType} />
    </>
  )
} ,  (prevProps , nextProps) => prevProps.val === nextProps.val) 

export default FileUpload