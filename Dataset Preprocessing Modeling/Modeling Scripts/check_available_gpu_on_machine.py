import tensorflow as tf


def check_gpu_availability():
    if tf.test.gpu_device_name():
        print(f'Default GPU Device: {tf.test.gpu_device_name()}')
    else:
        print("Please install GPU version of TF")


def main():
    check_gpu_availability()


if __name__ == '__main__':
    main()
