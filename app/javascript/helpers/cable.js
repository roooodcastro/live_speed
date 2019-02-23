import ActionCable from 'actioncable';

let consumer = null;

function createChannel(...args) {
  if (!consumer) consumer = ActionCable.createConsumer(); // eslint-disable-line no-undef

  return consumer.subscriptions.create(...args);
}

export default createChannel;
