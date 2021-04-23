/// Stack structure list implementation
import 'dart:collection';

class StackList<T> {
  final _stack = Queue<T>();

  // put new item to the top of Stack
  void push(T element) {
    _stack.addLast(element);
  }

  // remove topmost item from the stack, and return it
  T pop() {
    var lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  // return topmost item from the stack, without removing it
  T peek() {
    return _stack.last;
  }

  int get length => _stack.length;
}
