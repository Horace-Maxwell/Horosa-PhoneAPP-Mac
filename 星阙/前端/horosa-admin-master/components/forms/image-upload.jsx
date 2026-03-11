"use client";

import * as React from 'react';
import Image from 'next/image';
import { cn } from '@/lib/utils';
import { Input } from '../ui/input';

export default function ImageUpload({ value, onChange, className }) {

  const handleRemove = (event) => {
    event.preventDefault();
    event.stopPropagation();
    onChange?.(null);
  }

  const handleUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (event) => {
        onChange?.({
          name: file.name,
          src: event.target.result,
          size: file.size,
        });
      };
      reader.readAsDataURL(file);
    }
  }

  return (
    <div className={cn("flex space-x-4", className)}>
      <div className="relative w-20 h-20 rounded-md border-dashed border-2">
        {value
          ? (<div className='absolute inset-0'>
            <Image src={value} alt="icon" width={80} height={80} />
            <div className="absolute -top-2 -right-2 w-4 h-4 z-10 cursor-pointer" onClick={handleRemove}>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-4 h-4 fill-pink-600">
                <path d="M12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2C17.5228 2 22 6.47715 22 12C22 17.5228 17.5228 22 12 22ZM12 20C16.4183 20 20 16.4183 20 12C20 7.58172 16.4183 4 12 4C7.58172 4 4 7.58172 4 12C4 16.4183 7.58172 20 12 20ZM12 10.5858L14.8284 7.75736L16.2426 9.17157L13.4142 12L16.2426 14.8284L14.8284 16.2426L12 13.4142L9.17157 16.2426L7.75736 14.8284L10.5858 12L7.75736 9.17157L9.17157 7.75736L12 10.5858Z" />
              </svg>
            </div>
          </div>)
          : (<div className="absolute inset-0 flex flex-col space-y-1 items-center justify-center">
            <Input type="file" accept=".png, .jpg, .jpeg" className="absolute inset-0 w-full h-full cursor-pointer opacity-0" onChange={handleUpload} disabled={Boolean(value)} />
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5 fill-muted-foreground">
              <path d="M12 12.5858L16.2426 16.8284L14.8284 18.2426L13 16.415V22H11V16.413L9.17157 18.2426L7.75736 16.8284L12 12.5858ZM12 2C15.5934 2 18.5544 4.70761 18.9541 8.19395C21.2858 8.83154 23 10.9656 23 13.5C23 16.3688 20.8036 18.7246 18.0006 18.9776L18.0009 16.9644C19.6966 16.7214 21 15.2629 21 13.5C21 11.567 19.433 10 17.5 10C17.2912 10 17.0867 10.0183 16.8887 10.054C16.9616 9.7142 17 9.36158 17 9C17 6.23858 14.7614 4 12 4C9.23858 4 7 6.23858 7 9C7 9.36158 7.03838 9.7142 7.11205 10.0533C6.91331 10.0183 6.70879 10 6.5 10C4.567 10 3 11.567 3 13.5C3 15.2003 4.21241 16.6174 5.81986 16.934L6.00005 16.9646L6.00039 18.9776C3.19696 18.7252 1 16.3692 1 13.5C1 10.9656 2.71424 8.83154 5.04648 8.19411C5.44561 4.70761 8.40661 2 12 2Z" />
            </svg>
            <span className="text-xs text-muted-foreground">点击上传</span>
          </div>)
        }
      </div>
      <div className="flex flex-col space-y-1">
        <p className="text-xs">仅可上传 jpg/png 格式图片</p>
        <p className="text-xs">仅可上传一张图片</p>
        <p className="text-xs">图片体积不超过 100KB</p>
      </div>
    </div>
  )
}
