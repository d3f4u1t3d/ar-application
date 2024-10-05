import React, { memo } from 'react'
import './textField.scss'

const TextField = memo(({placeholder , val , label,onChangeHandler,name}) => {
  
  return (
    <>
    <div className='fieldSet'>
      <label className='label'>
        {label}
      </label>
      <input type='text' name={name} className='author_id' value={val} onChange={onChangeHandler} placeholder={placeholder}/>
    </div>
    </>
  )
} , (prevProps , nextProps) => prevProps.val === nextProps.val) 

export default TextField