#!/usr/bin/env python
# coding=utf-8
#
#   models.py
#       download the correct model from huggingface hub

from huggingface_hub import hf_hub_url, cached_download

def _get_model_dict(scale :int ) :
    if scale in (2, 4, 8) :
        return dict (
        repo_id='sberbank-ai/Real-ESRGAN',
        filename=f'RealESRGAN_x{scale}.pth')
    raise IndexError("supported models scales are 2, 4, 8")

def load_weights(self, model):
        if not os.path.exists(model_path) and download:
            config = HF_MODELS[self.scale]
            cache_dir = os.path.dirname(model_path)
            local_filename = os.path.basename(model_path)
            config_file_url = hf_hub_url(repo_id=config['repo_id'], filename=config['filename'])
            cached_download(config_file_url, cache_dir=cache_dir, force_filename=local_filename)
            print('Weights downloaded to:', os.path.join(cache_dir, local_filename))
        
        loadnet = torch.load(model_path)
        if 'params' in loadnet:
            self.model.load_state_dict(loadnet['params'], strict=True)
        elif 'params_ema' in loadnet:
            self.model.load_state_dict(loadnet['params_ema'], strict=True)
        else:
            self.model.load_state_dict(loadnet, strict=True)
        self.model.eval()
        self.model.to(self.device)