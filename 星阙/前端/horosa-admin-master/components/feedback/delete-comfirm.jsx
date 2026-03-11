"use client";

import * as React from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter, DialogClose } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { StorageUtils } from "@/lib/storage";
import { KEYS } from "@/constant/keys";

export const DeleteComfirm = ({ actions, row }) => {
  const [open, setOpen] = React.useState(false);

  const handleDelete = () => {
    console.log("handleDelete");
    fetch('https://api.horosa.com/admin/suggest/del', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': StorageUtils.get(KEYS.ACCESS_TOKEN),
      },
      body: JSON.stringify({ id: row.original.id })
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        actions?.list?.();
        setOpen(false);
      }
    })
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button
          variant="ghost"
          size="sm"
          className="text-red-500 hover:text-red-800"
        >
          删除
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader className="pb-4 border-b">
          <DialogTitle>删除反馈？</DialogTitle>
        </DialogHeader>
        <strong className="text-sm">{`您确定要删除【${row.getValue("name")}】的反馈吗？`}</strong>
        <DialogFooter>
          <DialogClose asChild>
            <Button
              variant="outline">
              取消
            </Button>
          </DialogClose>
          <Button variant="destructive" onClick={handleDelete}>
            删除
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}