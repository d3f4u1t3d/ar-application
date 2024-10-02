import React, { useState } from 'react'
import TextField from '../../components/TextField/TextField'
import FileUpload from '../../components/FileUpload/FileUpload'
import Button from '../../components/Button/Button'
import './homePage.scss'
import Line from '../../components/Line/Line'
import INPUT_CONSTANTS from '../../components/Constants/Input.constants'

const HomePage = () => {
  const [formData , setFormData] = useState({
    authorId:"",
    imageSet:[]
  })

  //add Image Set Section
  const addImageSet = () => {  
    console.log("add");
      
    setFormData (prev => {
      let temp = {
        id:prev.imageSet.length +1,
        markerImg:null,
        modelImg:null
      }
      prev.imageSet.unshift(temp);
      return {
        ...prev , 
      }
    })
  }

  //authorId Change
  const changeAuthorId = (e) => {
    let {name,value} = e.target;
    setFormData (prev => {
      return {
        ...prev , 
        [name]: value
      }
    })
  }

  //Change file Value
  const changeFileValue = (e,index,name) => {
    let newValue = e.target.files[0];
   setFormData(prev => {
    let position = prev.imageSet.length - index;
    prev.imageSet[position][name]=newValue;
    return {...prev}
   })
    
  }

  const deleteSet = (index) => {
    setFormData(prev => {
      let position = prev.imageSet.length - index;
      prev.imageSet.splice(position,1);
      return {...prev}
    })
  }
  const createRoom =() => {
    console.log(formData);
    
  }

  return (
    <>
    {/* Author Section */}
      <div className='author_id_section'>
        <TextField 
          label={INPUT_CONSTANTS.authorID.label} 
          placeholder={INPUT_CONSTANTS.authorID.placeholder} 
          val= {formData.authorId} 
          onChangeHandler = {changeAuthorId} 
          name={INPUT_CONSTANTS.authorID.name}/>
        <div className='right_section'>
        <div className='copy_btn_container'>
          <Button 
            buttonText={'copy code'} 
            purpose={'copy'}/>
        </div>
        </div>
      </div>
      <Line/>
      {/* Image Upload Section */}
      <div className='upload_section'>
        <div className='head'>
          <h1>
            Add Image Set
          </h1>
          <div className='right_section'>
            <div className='copy_btn_container'>
              <Button 
                buttonText={'Add Section'} 
                purpose={'add'} 
                onClickHandler={addImageSet}/>
            </div>
          </div>
        </div>
      </div>
      {/* Image Set Section */}
      <div className='image_set_section'>
      {
        formData.imageSet.map((el) => {
          return <>
                  <div className='single_set' key={el.id}>
                    <FileUpload 
                      placeholder={INPUT_CONSTANTS.markerImg.placeholder} 
                      name={INPUT_CONSTANTS.markerImg.name} 
                      val={el.markerImg} 
                      index = {el.id}  
                      onChangeHandler={changeFileValue}
                      fileType={INPUT_CONSTANTS.markerImg.type}/>
                    <div className='file_seperator'>
                    <Line/>
                    </div>
                    <FileUpload 
                      placeholder={INPUT_CONSTANTS.modelImg.placeholder} 
                      name = {INPUT_CONSTANTS.modelImg.name}
                      val={el.modelImg}  
                      index = {el.id} 
                      onChangeHandler={changeFileValue}
                      fileType={INPUT_CONSTANTS.modelImg.type}/>
                    <div className='delete_button_container'>
                    <Button 
                      buttonText={"Delete"} 
                      purpose={"dalete"} 
                      onClickHandler={() => deleteSet(el.id)}/>
                    </div>
                  </div>
                </>
        })
      }
      </div>

      {/* Create Room */}
      <div className='footer'>
        <div className='create_room_parent_container'>
          <div className='create_room_container'>
              <Button buttonText={'Create Room'} purpose={'create'} onClickHandler={createRoom}/>
            </div>
        </div>
      </div>
  </>
  )
}  

export default HomePage