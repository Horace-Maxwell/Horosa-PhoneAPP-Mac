// 节点类
import 'package:horosa/utils/log.dart';

class Node<T> {
  T data;
  Node<T>? next;
  Node<T>? prev;

  Node(this.data);
}

// 环形双向链表类
class CircularDoublyLinkedList<T> {
  Node<T>? head;
  Node<T>? tail;
  int _length = 0;

  // 返回链表的长度
  int get length => _length;

  // 判断链表是否为空
  bool get isEmpty => _length == 0;

  // 在链表尾部添加一个新节点
  void add(T data) {
    Node<T> newNode = Node(data);
    if (isEmpty) {
      head = newNode;
      tail = newNode;
      newNode.next = newNode;
      newNode.prev = newNode;
    } else {
      newNode.prev = tail;
      newNode.next = head;
      tail!.next = newNode;
      head!.prev = newNode;
      tail = newNode;
    }
    _length++;
  }

  // 删除链表中匹配数据的节点
  bool remove(T data) {
    if (isEmpty) return false;

    Node<T>? current = head;

    do {
      if (current!.data == data) {
        if (current == head && current == tail) {
          // 只有一个节点的情况
          head = null;
          tail = null;
        } else {
          // 链接前后的节点
          current.prev!.next = current.next;
          current.next!.prev = current.prev;

          if (current == head) {
            head = current.next;
          }
          if (current == tail) {
            tail = current.prev;
          }
        }
        _length--;
        return true;
      }
      current = current.next;
    } while (current != head);

    return false; // 未找到匹配数据
  }

  // 查找链表中是否存在此值，存在则返回该节点
  Node<T>? find(T data) {
    if (isEmpty) return null;

    Node<T>? current = head;
    do {
      if (current!.data == data) {
        return current;
      }
      current = current.next;
    } while (current != head);

    return null; // 未找到匹配数据
  }

  // 打印链表
  void printList() {
    if (isEmpty) {
      Log.i('链表为空');
      return;
    }

    Node<T>? current = head;
    do {
      Log.i(current!.data);
      current = current.next;
    } while (current != head);
  }
}